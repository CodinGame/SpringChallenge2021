package com.codingame.game;

import com.codingame.view.Serializer;

public class CubeCoord {
    static int[][] directions = new int[][] { { 1, -1, 0 }, { +1, 0, -1 }, { 0, +1, -1 }, { -1, +1, 0 }, { -1, 0, +1 }, { 0, -1, +1 } };
    int x, y, z;

    public CubeCoord(int x, int y, int z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public int getX() {
        return x;
    }

    public int getY() {
        return y;
    }

    public int getZ() {
        return z;
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + x;
        result = prime * result + y;
        result = prime * result + z;
        return result;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        CubeCoord other = (CubeCoord) obj;
        if (x != other.x)
            return false;
        if (y != other.y)
            return false;
        if (z != other.z)
            return false;
        return true;
    }

    CubeCoord neighbor(int orientation) {
        return neighbor(orientation, 1);
    }

    CubeCoord neighbor(int orientation, int distance) {
        int nx = this.x + directions[orientation][0] * distance;
        int ny = this.y + directions[orientation][1] * distance;
        int nz = this.z + directions[orientation][2] * distance;

        return new CubeCoord(nx, ny, nz);
    }

    int distanceTo(CubeCoord dst) {
        return (Math.abs(x - dst.x) + Math.abs(y - dst.y) + Math.abs(z - dst.z)) / 2;
    }

    @Override
    public String toString() {
        return Serializer.join(x, y, z);
    }

    public CubeCoord getOpposite() {
        CubeCoord oppositeCoord = new CubeCoord(-this.x, -this.y, -this.z);
        return oppositeCoord;
    }
    
    public static CubeCoord index_to_cubecoord(int index){
        // index to Cube coordinates (pointy) conversion.
        if (index==0) return new CubeCoord(0, 0, 0);

        int i = 1 + (int) Math.floor((Math.sqrt(12 * index - 3) - 3.0) / 6.0);
        int l_min = 1 + 3 * (i - 1) * i; // min index in this circle
        // int l_max = 3 * i * (i + 1);  // max index in this circle
        int x1 = index - l_min;          // linear offset 

        // euclidian div : x1 = a * i + d
        int o = x1 / i; // orientation index
        int d = x1 % i; // direction index

        int xi = directions[o][0] * i + directions[(o+2) % 6][0] * d;
        int yi = directions[o][1] * i + directions[(o+2) % 6][1] * d;
        int zi = directions[o][2] * i + directions[(o+2) % 6][2] * d;

        return new CubeCoord(xi, yi, zi);
    }

    
    public static int cubecoord_to_index(int x, int y, int z){
        // index to Cube coordinates (pointy) conversion.
        if (x==0 && y==0 && z==0) return 0;

        int I = Math.max(Math.abs(x), Math.max(Math.abs(y), Math.abs(z)));
        int i_off = 1 + 3 * (I - 1) * I;

        int index;
        if (x == I)
            index = i_off + 0 * I - z;
        else if (z == -I)
            index = i_off + 1 * I + y;
        else if (y == I)
            index = i_off + 2 * I - x;
        else if (x == -I)
            index = i_off + 3 * I + z;
        else if (z == I)
            index = i_off + 4 * I - y;
        else // if (y == -I)
            index = i_off + 5 * I + x;
    
        return index;
    }

    public static int cubecoord_to_index(CubeCoord cubecoord){
        return cubecoord_to_index(cubecoord.x, cubecoord.y, cubecoord.z);
    }

    public int cubecoord_to_index(){
        return cubecoord_to_index(this.x, this.y, this.z);
    }

}
